library(lingtypology)

# Основной датафрейм
df <- data.frame(
  language = c(
    "Aguaruna", "Alamblak", "Aneityum", "Anguthimri", "Awtuw", "Bardi", "Basque", "Bora", "Brahui", 
    "Brokpake", "Burushaski", "Candoshi-Shapra", "Cebuano", "Chukchi", "Chuvash", "Cofán", "Czech", 
    "Dhuwal", "Dime", "Dyirbal", "Aimele", "Epena", "Estonian", "Evenki", "Finnish", "Bench", 
    "Gooniyandi", "Kalaallisut", "Guugu Yimidhirr", "Amarakaeri", "Yagaria", "Hungarian", "Hunzib", 
    "Ingush", "Eastern Canadian Inuktitut", "North Alaskan Inupiatun", "Tipai", "Central Kanuri", 
    "Kenuzi-Dongola", "Ket", "Halh Mongolian", "Gamale Kham", "Koasati", "Krongo", "Kumbainggar", 
    "Kunama", "Kwaza", "Lak", "Lezgian", "Lithuanian", "Ma Manda", "Máku", "Malayalam", "Manambu", 
    "Mangarrayi", "Margany", "Maricopa", "Martuthunira", "Masalit", "Southern Sierra Miwok", 
    "Erzya", "Nez Perce", "Amur Nivkh", "Old Nubian", "Ama (Sudan)", "Eastern Oromo", 
    "Digor Ossetian", "Pitta Pitta", "Central Pomo", "Puinave", "Purik", "Rama", "Romani", "Saisiyat", 
    "Savosavo", "Serbian-Croatian-Bosnian", "Sumerian", "Taiap", "Tedaga", "Tlingit", "Tundra Nenets", 
    "Turkana", "Turkish", "Udihe", "Udmurt", "Ukrainian", "Wajarri", "Wappo", "Warrongo", "Wemba wemba", 
    "Yakkha", "Yauyos Quechua", "Northern Yokuts", "Yukaghir", "Central Alaskan Yupik"
  ),
  features = c(
    "Chicham", "Sepik", "Austronesian", "Pama-Nyungan", "Sepik", "Nyulnyulan", "isolate", "Boran", 
    "Dravidian", "Sino-Tibetan", "isolate", "isolate", "Austronesian", "Chukotko-Kamchatkan", 
    "Turkic", "isolate", "Indo-European", "Pama-Nyungan", "South Omotic", "Pama-Nyungan", "Bosavi", 
    "Chocoan", "Uralic", "Tungusic", "Uralic", "Ta-Ne-Omotic", "Bunuban", "Eskimo-Aleut", 
    "Pama-Nyungan", "Harakmbut", "Trans-New-Guinea", "Uralic", "Nakh-Daghestanian", "Nakh-Daghestanian", 
    "Eskimo-Aleut", "Eskimo-Aleut", "Yuman", "Saharan", "Nubian", "Yeniseian", "Mongolic-Khitan", 
    "Sino-Tibetan", "Muskogean", "Kadu", "Pama-Nyungan", "Kunama", "isolate", "Nakh-Daghestanian", 
    "Nakh-Daghestanian", "Indo-European", "Nuclear Trans New Guinea", "isolate", "Dravidian", "Ndu", 
    "Mangarrayi-Maran", "Pama-Nyungan", "Cochimi-Yuman", "Pama-Nyungan", "Maban", 
    "Miwok-Costanoan", "Uralic", "Sahaptian", "Nivkhic", "Nubian", "Nyimang", 
    "Afro-Asiatic", "Indo-European", "Pama-Nyungan", "Pomoan", "isolate", "Sino-Tibetan", "Chibchan", 
    "Indo-European", "Austronesian", "Central Solomons", "Indo-European", "isolate", "isolate", 
    "Saharan", "Athabaskan-Eyak-Tlingit", "Uralic", "Nilotic", "Turkic", "Tungusic", "Uralic", 
    "Indo-European", "Pama-Nyungan", "Yuki-Wappo", "Pama-Nyungan", "Pama-Nyungan", "Sino-Tibetan", 
    "Quechuan", "Yokutsan", "Yukaghir", "Eskimo-Aleut")
)

# Добавляем координаты из lingtypology
df$latitude <- lat.lang(df$language)
df$longitude <- long.lang(df$language)

# Таблица для языков, которых нет в базе
custom_coords <- data.frame(
  language = c("Mehweb", "Muylaq' Aymara"),
  features = c("Maban", "Aymaran"),
  latitude = c(42.25, -16.5),
  longitude = c(143.0, -70.7833)
)

# Объединение
df_combined <- merge(df, custom_coords, by = "language", all = TRUE)

# Объединяем столбцы features
df_combined$features <- ifelse(
  is.na(df_combined$features.x),
  df_combined$features.y,
  df_combined$features.x
)

# То же самое с координатами
df_combined$latitude <- ifelse(
  is.na(df_combined$latitude.x),
  df_combined$latitude.y,
  df_combined$latitude.x
)
df_combined$longitude <- ifelse(
  is.na(df_combined$longitude.x),
  df_combined$longitude.y,
  df_combined$longitude.x
)

# Удаляем лишние колонки
df_combined <- subset(df_combined, select = c(language, features, latitude, longitude))

# Строим карту
map <- map.feature(
  languages = df_combined$language,
  features = df_combined$features,
  latitude = df_combined$latitude,
  longitude = df_combined$longitude
)

map

htmlwidgets::saveWidget(map, file = "language_map.html", selfcontained = TRUE)

