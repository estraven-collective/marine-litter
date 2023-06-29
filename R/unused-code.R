# olm_path <- here::here('data/olm-data.csv')
# olm_ds <- read_csv(olm_path)

# temp_amount <- mlw_ds %>%
#   mutate(GTOT = rowSums(across(G1:G213), na.rm = T)) %>%
#   group_by(BeachCountrycode) %>%
#   summarize(tot_amount = sum(GTOT)) %>%
#   top_n(5, tot_amount)
# 
# temp_events <- mlw_ds %>%
#   group_by(BeachCountrycode) %>%
#   summarize(count_events = n()) %>%
#   top_n(5, count_events)
# 
# temp_locs <- mlw_ds %>%
#   group_by(BeachCountrycode) %>%
#   summarize(count_beach = n_distinct(BeachName)) %>%
#   top_n(5, count_beach)
# 
# temp_italy <- mlw_ds %>%
#   group_by(BeachCountrycode, BeachRegionalSea) %>%
#   summarize(count_beach = n_distinct(BeachName)) %>%
#   filter(BeachCountrycode == "IT")

###

# mlw_it_poly <- mlw_it %>%
#   rowwise() %>%
#   mutate(lon = list(c(lon_x1, lon_x2, lon_x2, lon_x1, lon_x1)),
#          lat = list(c(lat_y1, lat_y1, lat_y2, lat_y2, lat_y1))) %>%
#   ungroup() %>%
#   unnest_legacy(lon, lat) %>%
#   relocate(c(lon, lat), .before = lon_x1) %>%
#   st_as_sf(coords = c("lon", "lat"), crs = st_crs(italy)) %>%
#   group_by(ID) %>%
#   mutate(geometry = st_combine(geometry)) %>%
#   st_cast("POLYGON") %>%
#   filter(row_number() == 1) %>%
#   ungroup()

# ### PLOT 3
# 
# df3 <- mlw_it_pts %>%
#   
#   relocate(geometry, .before = G1) %>%
#   relocate(EventDate, .before = CommunityName) %>%
#   group_by(across(CommunityName:geometry)) %>%
#   summarize(across(G1:G213, ~ sum(.x, na.rm = TRUE))) %>%
#   mutate(GTOT = rowSums(across(G1:G213), na.rm = T)) %>%
#   ungroup() %>%
#   
#   gather(key = "generalcode", value = "amount", G1:G213) %>%
#   left_join(mlw_meta, by = "generalcode") %>%
#   
#   group_by(category) %>%
#   summarize(tot_amount = sum(amount))
# 
# mypal <- c(pal_nejm("default")(8), "grey")
# 
# plot3 <- ggplot(data = df3) +
#   geom_point(aes(x = tot_amount, y = fct_reorder(category, tot_amount),
#                  color = category),
#              alpha = 0.7, stroke = 1, size = 12) +
#   scale_color_manual(values = mypal) +
#   scale_x_sqrt() +
#   labs(x = "Total amount collected (sqrt scale)", y = "Litter category",
#        color = "Litter category",
#        title = "Total litter amount by category") +
#   theme(panel.background = element_blank(),
#         panel.grid.major.x = element_blank(),
#         panel.grid.major.y = element_line(color = "#ECEFF1"),
#         plot.margin = unit(c(2, 1, 2, 1), "cm"),
#         plot.title = element_text(size = 16, hjust = 0.5, margin = unit(c(10, 0, 5, 0), "pt"))
#   )
# 
# ggsave(plot3, filename = "plot3.png", width = 15, height = 9.375)

# # TENTATIVO UNIFORMAZIONE OLM MLW
# 
# olm_categories <- as_tibble(cbind(spec = colnames(olm_ds), category = NA))
# 
# olm_categories <- mlw_categories %>%
#   mutate(category = case_when(
#     grepl("plastic", spec, ignore.case = T) ~ "Plastic",
#     grepl("metal|can|aluminium", spec, ignore.case = T) ~ "Metal",
#     grepl("paper", spec, ignore.case = T) ~ "Paper/Cardboard",
#     grepl("glass", spec, ignore.case = T) ~ "Glass/ceramics",
#     grepl("wood", spec, ignore.case = T) ~ "Processed/worked wood",
#     grepl("chemical", spec, ignore.case = T) ~ "Chemicals",
#     grepl("rubber", spec, ignore.case = T) ~ "Rubber"
#          )
#     )

