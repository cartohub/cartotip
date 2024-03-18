library(arcgislayers)
library(tidyverse)
library(basemaps)
library(sf)
library(ggspatial)
library(extrafont)

areas_amortiguamiento_url <- 'https://www.idep.gob.pe/geoportal/rest/services/INSTITUCIONALES/SERNANP/MapServer/6'
peru_limites_url <- 'https://github.com/ambarja/gpkg-pe/raw/main/departamentos.gpkg'

areas_amortiguamiento <- arc_open(url) |> 
  arc_select() |> 
  st_transform(crs = 3857)

peru <- read_sf(peru_limites_url) |> 
  summarise() |> 
  st_bbox() |> 
  st_as_sfc() |> 
  st_buffer(dist = 0.01)

ggplot() + 
  basemap_gglayer(
    peru,
    map_service = "carto",
    map_type = "light") +
  scale_fill_identity() + 
  geom_sf(
    data = areas_amortiguamiento,
    fill = '#55a630') +
  labs(
    x = "",
    y = "",
    title = "Zonas de Amortiguamiento",
    subtitle = "Datos de Sernamp",
    caption = "Creado por Antony Barja - CartoHub") + 
  annotation_north_arrow(location = 'rt') + 
  annotation_scale() + 
  theme_bw() + 
  theme(
    plot.title = element_text(size = 20,face = 'bold',family = 'Roboto Slab'),
    plot.subtitle = element_text(family = 'Roboto Slab'),
    plot.caption = element_text(family = 'Lucida Console'),
    axis.text = element_text(family = 'Roboto Slab'),
    panel.grid = element_blank(),
    panel.border = element_blank()) + 
  coord_sf(expand = F) 

ggsave(
    'cartotip-01.png',
    plot = last_plot())