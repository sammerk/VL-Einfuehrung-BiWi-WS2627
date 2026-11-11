# Simuliert Daten zum Quasiexperiment (Folie "Expertiseforschung")
# und speichert den Plot nach images/dotplot-erwartung.png.
# Ausführen aus dem Projektordner: source("scripts/dotplot-erwartung.R")
library(ggplot2)
set.seed(7316)

lev <- c("Expert:innen", "Desinteressierte")
daten <- expand.grid(
  id = 1:25,
  gruppe = lev,
  abbildung = c("Abbildung 1 (sinnvoll)", "Abbildung 2 (vertauscht)")
)
daten$p <- with(daten, ifelse(
  abbildung == "Abbildung 1 (sinnvoll)",
  ifelse(gruppe == "Expert:innen", 0.80, 0.30),
  ifelse(gruppe == "Expert:innen", 0.28, 0.27)
))
daten$richtig <- rbinom(nrow(daten), size = 11, prob = daten$p)
d2 <- transform(daten, gruppe = factor(gruppe, levels = lev))

n_exp <- sum(d2$gruppe == "Expert:innen" & d2$abbildung == "Abbildung 1 (sinnvoll)" & d2$richtig == 8)
n_des <- sum(d2$gruppe == "Desinteressierte" & d2$abbildung == "Abbildung 2 (vertauscht)" & d2$richtig == 5)
d <- 0.135
anno <- data.frame(
  gruppe = factor(lev, levels = lev),
  abbildung = c("Abbildung 1 (sinnvoll)", "Abbildung 2 (vertauscht)"),
  x_txt = c(-0.3, 6.2), y_txt = c(1.0, 1.05),
  x_start = c(4.2, 6.9), y_start = c(0.62, 0.5),
  x_dot = c(7.6, 5.4), y_dot = c(n_exp, n_des) * d - d / 2,
  label = c(sprintf("%s Expert:innen haben\n8 Spieler korrekt aus\nAbb. 1 rekonstruiert", n_exp),
            sprintf("%s Desinteressierte\nhaben 5 Spieler\nkorrekt aus Abb. 2\nrekonstruiert", n_des))
)

p <- ggplot(d2, aes(richtig, fill = gruppe)) +
  geom_dotplot(binwidth = 1, stackgroups = TRUE, binpositions = "all",
               method = "histodot", dotsize = 0.9, colour = "white") +
  geom_text(data = anno, aes(x_txt, y_txt, label = label),
            hjust = 0, vjust = 1, size = 3.3, colour = "#32414B", lineheight = 0.95,
            inherit.aes = FALSE) +
  geom_curve(data = anno[1, ], aes(x = x_start, y = y_start, xend = x_dot, yend = y_dot),
             curvature = 0.3, colour = "#32414B", linewidth = 0.5,
             arrow = arrow(length = unit(2.5, "mm"), type = "closed"), inherit.aes = FALSE) +
  geom_curve(data = anno[2, ], aes(x = x_start, y = y_start, xend = x_dot, yend = y_dot),
             curvature = -0.4, colour = "#32414B", linewidth = 0.5,
             arrow = arrow(length = unit(2.5, "mm"), type = "closed"), inherit.aes = FALSE) +
  facet_grid(gruppe ~ abbildung, axes = "all_x", axis.labels = "all") +
  scale_fill_manual(values = c("Expert:innen" = "#A51E37", "Desinteressierte" = "#B4A069")) +
  scale_x_continuous(limits = c(-0.5, 11.5), breaks = 0:11) +
  scale_y_continuous(NULL, breaks = NULL, limits = c(0, 1.1)) +
  labs(x = "Korrekt rekonstruierte Spieler (von 11)", fill = NULL) +
  theme_minimal(base_size = 13) +
  theme(
    text = element_text(colour = "#32414B"),
    panel.grid = element_blank(),
    axis.line.x = element_line(colour = "#32414B"),
    strip.text = element_text(face = "bold", colour = "#32414B"),
    legend.position = "none"
  )

ggsave("images/dotplot-erwartung.png", p, width = 7, height = 5, dpi = 200, bg = "white")
