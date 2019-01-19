hook.Add("PopulateToolMenu", "DrGHUDPopulateToolMenu", function()
	spawnmenu.AddToolMenuOption("Options", "DrGHUD", "DrGHUDServerSettings", "Server Settings", "", "", function(panel)
	   panel:ClearControls()
     panel:ControlHelp("\nMisc\n")
     panel:CheckBox("Allow entity info", "drghud_allow_entityinfo")
     panel:NumSlider("Rotate compass", "drghud_compass_rotate", 0, 359, 0)
     panel:ControlHelp("\nRadar\n")
     panel:CheckBox("Allow radar", "drghud_allow_radar")
     panel:NumSlider("Radar range", "drghud_radar_range", 0, 15000, 0)
     panel:NumSlider("Death icon", "drghud_radar_death", -1, 3600, 0)
  end)
  spawnmenu.AddToolMenuOption("Options", "DrGHUD", "DrGHUDClientSettings", "Client Settings", "", "", function(panel)
	   panel:ClearControls()
     panel:ControlHelp("\nMisc\n")
     panel:CheckBox("Enable DrGHUD", "drghud")
     panel:NumSlider("HUD scale", "drghud_scale", 0.1, 3, 1)
     panel:NumSlider("Blur quality", "drghud_blur", 0, 5, 0)
     panel:CheckBox("Hide zoom HUD", "drghud_zoom")
     panel:ControlHelp("\nEnable/disable\n")
     panel:CheckBox("Enable health/armor", "drghud_status")
		 panel:CheckBox("Enable ammo display", "drghud_ammo")
     panel:CheckBox("Enable status effects", "drghud_status_effects")
     panel:CheckBox("Enable information", "drghud_info")
     panel:CheckBox("Enable entity info", "drghud_entityinfo")
     --panel:CheckBox("Enable vehicle display", "drghud_vehicles")
		 --panel:CheckBox("Weapon selection", "drghud_weapons")
     panel:ControlHelp("\nRadar/compass\n")
     panel:CheckBox("Enable radar", "drghud_radar")
     panel:NumSlider("Radar scale", "drghud_radar_scale", 0.1, 3, 1)
     panel:CheckBox("Enable compass", "drghud_compass")
     panel:CheckBox("North only", "drghud_compass_north_only")
		 panel:ControlHelp("\nColors")
		 panel:AddControl("color", {
			label = "Main color",
			red = "drghud_main_r",
			green = "drghud_main_g",
			blue = "drghud_main_b"
	   })
		 panel:AddControl("color", {
			label = "Health color (high)",
			red = "drghud_health_r",
			green = "drghud_health_g",
			blue = "drghud_health_b"
	   })
		 panel:AddControl("color", {
			label = "Health color (low)",
			red = "drghud_damage_r",
			green = "drghud_damage_g",
			blue = "drghud_damage_b"
	   })
		 panel:AddControl("color", {
			label = "Armor color",
			red = "drghud_armor_r",
			green = "drghud_armor_g",
			blue = "drghud_armor_b"
	   })
		 panel:AddControl("color", {
			label = "Primary ammo color",
			red = "drghud_ammo_r",
			green = "drghud_ammo_g",
			blue = "drghud_ammo_b"
	   })
		 panel:AddControl("color", {
			label = "Secondary ammo color",
			red = "drghud_secammo_r",
			green = "drghud_secammo_g",
			blue = "drghud_secammo_b"
	   })
		 panel:AddControl("color", {
			label = "Neutral entities",
			red = "drghud_radar_neutral_r",
			green = "drghud_radar_neutral_g",
			blue = "drghud_radar_neutral_b"
	   })
		 panel:AddControl("color", {
			label = "Allied entities",
			red = "drghud_radar_ally_r",
			green = "drghud_radar_ally_g",
			blue = "drghud_radar_ally_b"
	   })
		 panel:AddControl("color", {
			label = "Enemy entities",
			red = "drghud_radar_enemy_r",
			green = "drghud_radar_enemy_g",
			blue = "drghud_radar_enemy_b"
	   })
		 panel:AddControl("color", {
			label = "Weapon entities",
			red = "drghud_radar_weapon_r",
			green = "drghud_radar_weapon_g",
			blue = "drghud_radar_weapon_b"
	   })
		 panel:AddControl("color", {
			label = "Vehicle entities",
			red = "drghud_radar_vehicle_r",
			green = "drghud_radar_vehicle_g",
			blue = "drghud_radar_vehicle_b"
	   })
  end)
  spawnmenu.AddToolMenuOption("Options", "DrGHUD", "DrGHUDCrosshair", "Crosshair", "", "", function(panel)
	   panel:ClearControls()
		 panel:ControlHelp("\nMisc\n")
     panel:CheckBox("Enable crosshair", "drghud_crosshair")
		 panel:CheckBox("Color change", "drghud_crosshair_color_change")
     panel:ControlHelp("\nCenter\n")
     panel:CheckBox("Center point", "drghud_crosshair_center")
     panel:NumSlider("Point size", "drghud_crosshair_center_size", 0.1, 10, 1)
     panel:CheckBox("Point full", "drghud_crosshair_center_full")
     panel:AddControl("color", {
			red = "drghud_crosshair_center_r",
			green = "drghud_crosshair_center_g",
			blue = "drghud_crosshair_center_b",
			alpha = "drghud_crosshair_center_a"
	   })
     panel:ControlHelp("\nSides\n")
     panel:NumSlider("Side points", "drghud_crosshair_sides", 0, 16, 0)
     panel:CheckBox("Points full", "drghud_crosshair_sides_full")
     panel:NumSlider("Points size", "drghud_crosshair_sides_size", 0.1, 10, 1)
     panel:NumSlider("Points rotation", "drghud_crosshair_sides_rotation", 0, 359, 0)
     panel:NumSlider("Points distance", "drghud_crosshair_sides_distance", 0, 15, 1)
     panel:AddControl("color", {
			red = "drghud_crosshair_sides_r",
			green = "drghud_crosshair_sides_g",
			blue = "drghud_crosshair_sides_b",
			alpha = "drghud_crosshair_sides_a"
	   })
  end)
end)
