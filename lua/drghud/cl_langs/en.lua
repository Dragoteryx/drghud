hook.Add("DrG/LoadLanguages", "DrGHUD/EnglishLanguage", function()
  local lang = DrGBase.GetOrCreateLanguage("en")

  lang:Set("drghud.status.health", "Health")
  lang:Set("drghud.status.armor", "Armor")

  lang:Set("drghud.entity_info.health", "Health")

  lang:Set("drghud.compass.north", "N")
  lang:Set("drghud.compass.south", "S")
  lang:Set("drghud.compass.east", "E")
  lang:Set("drghud.compass.west", "W")
end)