library(tidyverse)
library(readr)
library(ggsci)
library(sf)

### PLOT 1

df1 <- mlw_it_pts %>%
  
  relocate(geometry, .before = G1) %>%
  relocate(EventDate, .before = CommunityName) %>%
  group_by(across(CommunityName:geometry)) %>%
  summarize(across(G1:G213, ~ sum(.x, na.rm = TRUE))) %>%
  mutate(GTOT = rowSums(across(G1:G213), na.rm = T)) %>%
  ungroup() %>%
  
  gather(key = "generalcode", value = "amount", G1:G213) %>%
  left_join(mlw_meta, by = "generalcode") %>%
  
  relocate(category, .after = geometry) %>%
  group_by(across(CommunityName:category)) %>%
  summarize(tot_amount = sum(amount))


plot1 <- ggplot() +
  geom_sf(data = italy) +
  geom_point(data = df1,
             aes(geometry = geometry, size = tot_amount),
             stat = "sf_coordinates", alpha = 0.5,
             # position = position_jitter(w = 0.50),
             show.legend = T) +
  coord_sf(datum = NA) +
  theme(panel.background = element_blank(),
        axis.title = element_blank())

ggsave(plot1, filename = "plot1.png", width = 15, height = 9.375)


### PLOT 2

df2 <- mlw_it_pts %>%

  relocate(geometry, .before = G1) %>%
  relocate(EventDate, .before = CommunityName) %>%
  group_by(across(CommunityName:geometry)) %>%
  summarize(across(G1:G213, ~ sum(.x, na.rm = TRUE))) %>%
  mutate(GTOT = rowSums(across(G1:G213), na.rm = T)) %>%
  ungroup() %>%

  gather(key = "generalcode", value = "amount", G1:G213) %>%
  left_join(mlw_meta, by = "generalcode") %>%

  group_by(category, generalname) %>%
  summarize(tot_amount = sum(amount)) %>%
  ungroup() %>%
  top_n(25, wt = tot_amount)

plot2 <- ggplot(data = df2) +
  geom_point(aes(x = tot_amount, y = fct_reorder(generalname, tot_amount),
                 size = tot_amount, color = category),
             alpha = 0.7, stroke = 1) +
  scale_color_nejm() +
  scale_size(range = c(1, 8)) +
  labs(x = "Total amount collected", y = "General item name",
       color = "Litter category", size = "Total amount collected",
       title = "Top 25 litter items collected") +
  theme(panel.background = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(color = "#ECEFF1"),
        plot.margin = unit(c(2, 1, 2, 1), "cm"),
        plot.title = element_text(size = 16, hjust = 0.5, margin = unit(c(10, 0, 5, 0), "pt"))
        )

ggsave(plot2, filename = "plot2.png", width = 15, height = 9.375)




### Quanti oggetti in 10mq?


#### INTERSECTION MARINE & BEACH

df1 <- df1 %>%
  rowid_to_column(var = "id")

df1 <- cbind(df1, st_nearest_feature(df1, marine_regions_s)) %>%
  rename(MarineRegion = st_nearest_feature.df1..marine_regions_s.) %>%
  mutate(MarineRegion = fct_recode(as_factor(MarineRegion), 
                                   "Adriatic Sea" = "1", 
                                   "Ionian Sea and the Central Mediterranean Sea" = "3",
                                   "Western Mediterranean Sea" = "4"))

xlim <- c(4, 37)
ylim <- c(20, 47)

plot_inter <- ggplot() +
  geom_sf(data = italy) +
  geom_point(data = df1 %>% filter(category == "Plastic"),
             aes(geometry = geometry, size = tot_amount, color = MarineRegion),
             stat = "sf_coordinates", alpha = 0.5,
             # position = position_jitter(w = 0.50),
             show.legend = T) +
  # geom_sf(data = marine_regions_s) +
  coord_sf(datum = NA)