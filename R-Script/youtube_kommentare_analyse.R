##############################
# Daten laden und vorbereiten
##############################

# Bibliotheken laden
library(tidyverse)
library(ggplot2)

# Daten laden
comments_data <- read.csv("filtered_youtube_comments.csv")

# Spaltennamen vereinheitlichen und relevante Kommentare filtern
colnames(comments_data) <- tolower(colnames(comments_data))
relevant_comments <- comments_data %>%
  filter(relevance.keep.for.review == 1)

##############################
# Häufigkeiten und Verteilungen
##############################

# Kategorien-Häufigkeiten
category_summary <- relevant_comments %>%
  summarise(
    kategorisierung = sum(kategorisierung, na.rm = TRUE),
    vergleich = sum(vergleich, na.rm = TRUE),
    distinktheit = sum(distinktheit, na.rm = TRUE),
    repräsentation = sum(repräsentation, na.rm = TRUE),
    stereotypen = sum(stereotypen, na.rm = TRUE),
    identität = sum(identität, na.rm = TRUE),
    sagbarkeitsfeld = sum(sagbarkeitsfeld, na.rm = TRUE),
    macht_wissen = sum(macht_wissen, na.rm = TRUE),
    fantasy_booking = sum(fantasy_booking, na.rm = TRUE)
  ) %>%
  pivot_longer(cols = everything(), names_to = "kategorie", values_to = "anzahl") %>%
  mutate(prozent = round((anzahl / nrow(relevant_comments)) * 100, 2))

# Verteilung der Diskurspositionen
position_summary <- relevant_comments %>%
  group_by(position) %>%
  summarise(anzahl = n()) %>%
  mutate(prozent = round((anzahl / nrow(relevant_comments)) * 100, 2))

# Diskurspositionen je Kategorie
position_category_summary <- relevant_comments %>%
  pivot_longer(cols = c("kategorisierung", "vergleich", "distinktheit", 
                        "repräsentation", "stereotypen", "identität", 
                        "sagbarkeitsfeld", "macht_wissen", "fantasy_booking"),
               names_to = "kategorie", values_to = "aktiv") %>%
  filter(aktiv == 1) %>%
  group_by(kategorie, position) %>%
  summarise(anzahl = n(), .groups = "drop") %>%
  group_by(kategorie) %>%
  mutate(prozent = round((anzahl / sum(anzahl)) * 100, 2))

##############################
# Kombinationen und Likes
##############################

# Paarweise Kombinationen von Kategorien
relevant_category_columns <- c("kategorisierung", "vergleich", "distinktheit", 
                               "repräsentation", "stereotypen", "identität", 
                               "sagbarkeitsfeld", "macht_wissen", "fantasy_booking")

category_combinations <- combn(relevant_category_columns, 2, simplify = FALSE) %>%
  map_df(~ tibble(kategorie1 = .x[1], kategorie2 = .x[2])) %>%
  rowwise() %>%
  mutate(
    gemeinsame_anzahl = sum(
      relevant_comments[[kategorie1]] == 1 & relevant_comments[[kategorie2]] == 1, na.rm = TRUE
    )
  ) %>%
  filter(gemeinsame_anzahl > 0) %>%
  ungroup()

print(category_combinations, n=36)

# Likes-Statistiken
likes_stats <- relevant_comments %>%
  pivot_longer(cols = all_of(relevant_category_columns), names_to = "kategorie", values_to = "aktiv") %>%
  filter(aktiv == 1) %>%
  group_by(kategorie) %>%
  summarise(
    durchschnitt_likes = mean(likes, na.rm = TRUE),
    median_likes = median(likes, na.rm = TRUE),
    max_likes = max(likes, na.rm = TRUE),
    min_likes = min(likes, na.rm = TRUE),
    .groups = "drop"
  )

likes_by_position <- relevant_comments %>%
  group_by(position) %>%
  summarise(
    durchschnitt_likes = mean(likes, na.rm = TRUE),
    median_likes = median(likes, na.rm = TRUE),
    max_likes = max(likes, na.rm = TRUE),
    min_likes = min(likes, na.rm = TRUE),
    .groups = "drop"
  )

##############################
# Visualisierungen
##############################

# Kategorien-Verteilung
category_plot <- ggplot(category_summary, aes(x = reorder(kategorie, anzahl), y = anzahl)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_text(aes(label = paste0(prozent, "%")), hjust = -0.1) +
  coord_flip() +
  scale_x_discrete(
    labels = c(
      "kategorisierung" = "Soziale Kategorisierung",
      "vergleich" = "Soziale Vergleichsprozesse",
      "distinktheit" = "Positive soziale Distinktheit",
      "repräsentation" = "Repräsentation",
      "stereotypen" = "Stereotypen",
      "identität" = "Identität",
      "sagbarkeitsfeld" = "Sagbarkeitsfelder",
      "macht_wissen" = "Macht- und Wissensverhältnisse",
      "fantasy_booking" = "Fantasy Booking"
    )
  ) +
  labs(x = NULL, y = "Anzahl der Kommentare") +
  theme_minimal()

print(category_plot)

# Diskurspositionen
position_plot <- ggplot(position_summary, aes(x = factor(position, levels = c(1, 2, 3)), y = anzahl, fill = factor(position))) +
  geom_bar(stat = "identity", width = 0.7) +
  geom_text(aes(label = paste0(prozent, "%")), vjust = -0.3, size = 4) +
  scale_fill_manual(
    values = c("1" = "#6AA84F", "2" = "#FFD966", "3" = "#E06666"),
    labels = c("1" = "Positiv", "2" = "Neutral", "3" = "Negativ")
  ) +
  labs(x = NULL, y = "Anzahl der Kommentare", fill = "Diskursposition") +
  theme_minimal()

print(position_plot)

# Diskurspositionen je Kategorie
position_category_plot <- ggplot(position_category_summary, aes(x = kategorie, y = prozent, fill = factor(position))) +
  geom_bar(stat = "identity", position = "stack", width = 0.7) +
  geom_text(
    aes(label = ifelse(prozent > 5, paste0(prozent, "%"), "")), 
    position = position_stack(vjust = 0.5), size = 3
  ) +
  scale_fill_manual(
    values = c("1" = "#6AA84F", "2" = "#FFD966", "3" = "#E06666"),
    labels = c("1" = "Positiv", "2" = "Neutral", "3" = "Negativ")
  ) +
  scale_x_discrete(
    labels = c(
      "kategorisierung" = "Soziale Kategorisierung",
      "vergleich" = "Soziale Vergleichsprozesse",
      "distinktheit" = "Positive soziale Distinktheit",
      "repräsentation" = "Repräsentation",
      "stereotypen" = "Stereotypen",
      "identität" = "Identität",
      "sagbarkeitsfeld" = "Sagbarkeitsfelder",
      "macht_wissen" = "Macht- und Wissensverhältnisse",
      "fantasy_booking" = "Fantasy Booking"
    )
  ) +
  labs(x = NULL, y = "Prozent", fill = "Diskursposition") +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1))

print(position_category_plot)

# Likes pro Kategorie
likes_plot <- ggplot(likes_stats, aes(x = reorder(kategorie, -durchschnitt_likes), y = durchschnitt_likes, fill = kategorie)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = round(durchschnitt_likes, 1)), vjust = -0.5, size = 4) +
  scale_fill_viridis_d() +
  scale_x_discrete(
    labels = c(
      "kategorisierung" = "Soziale Kategorisierung",
      "vergleich" = "Soziale Vergleichsprozesse",
      "distinktheit" = "Positive soziale Distinktheit",
      "repräsentation" = "Repräsentation",
      "stereotypen" = "Stereotypen",
      "identität" = "Identität",
      "sagbarkeitsfeld" = "Sagbarkeitsfelder",
      "macht_wissen" = "Macht- und Wissensverhältnisse",
      "fantasy_booking" = "Fantasy Booking"
    )
  ) +
  labs(x = NULL, y = "Durchschnittliche Likes") +
  theme_minimal() +
  theme(legend.position = "none", axis.text.x = element_text(angle = 45, hjust = 1))

print(likes_plot)

