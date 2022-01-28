hook.Add("DrG/LoadLanguages", "DrGHUD/FrenchLanguage", function()
  local lang = DrGBase.GetOrCreateLanguage("fr")

  lang:Set("drghud.status.health", "Santé")
  lang:Set("drghud.status.armor", "Armure")

  lang:Set("drghud.entity_info.health", "Santé")

  lang:Set("drghud.compass.north", "N")
  lang:Set("drghud.compass.south", "S")
  lang:Set("drghud.compass.east", "E")
  lang:Set("drghud.compass.west", "O")
end)