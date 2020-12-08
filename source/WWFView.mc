using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Activity;

class WWFView extends WatchUi.WatchFace {

	var fields;

    function initialize() {

        WatchFace.initialize();
        memoryCache = new MemoryCache();
        Application.getApp().registerEvents();
        fonts = {};
        fields = {};
        fonts[:time] = Application.loadResource(Rez.Fonts.big);
        fonts[:small] = Application.loadResource(Rez.Fonts.small);
        fonts[:medium] = Application.loadResource(Rez.Fonts.med);
        fonts[:picture] = Application.loadResource(Rez.Fonts.images);
        fonts[:weather] = Application.loadResource(Rez.Fonts.weather);
    }

    // Load your resources here
    function onLayout(dc) {
    	//createFields(dc);
	}
	
	function createFields(dc){
		
		fields = {};
		///////////////////////////////////////////////////////////////////////
		//TIME
		var font = fonts[:time];
		var w = dc.getTextWidthInPixels("00:00", font);
		var h = Graphics.getFontHeight(font)-Graphics.getFontDescent(font);
		var x = (System.getDeviceSettings().screenWidth - w)/2;
		var y = (System.getDeviceSettings().screenHeight - h)/2;

        fields[:time] = new SimpleField(
    		{
    			:x => x,
    			:y => y,
    			:h => h,
    			:w => w,
    			:type => :time,
    			:id => :time,
    			:fontId => :time,
    			:justify => Graphics.TEXT_JUSTIFY_CENTER
    		}
    	);

		///////////////////////////////////////////////////////////////////////
		//DATE
    	font = fonts[:small];
    	h = 20;
    	y = y - h;
    	memoryCache.setBackgroundY(0, y);

        fields[:date] = new SimpleField(
    		{
    			:x => x,
    			:y => y,
    			:h => h,
    			:w => w,
    			:type => :date,
    			:id => :date,
    			:fontId => :small,
    			:justify => Graphics.TEXT_JUSTIFY_CENTER
    		}
    	);

		///////////////////////////////////////////////////////////////////////
		//STATUS FIELDS
		h = 16 + fields[:date].h/4;
		w = h;
		
		y = fields[:date].y;
		x = fields[:time].x - w - 3;

		var coord = new [STATUS_FIELDS_COUNT];
		coord[0] = [x,y];
		coord[1] = [coord[0][0],y + h];
		coord[2] = [coord[0][0],y + 2*h];
		coord[3] = [coord[0][0],y + 3*h];
		
		coord[4] = [fields[:time].x + fields[:time].w + 3,y];
		coord[5] = [coord[4][0],y + h];
		coord[6] = [coord[4][0],y + 2*h];
		coord[7] = [coord[4][0],y + 3*h];
		

		for (var i = 0; i < STATUS_FIELDS_COUNT; i++){
			
			var id = "SF"+i;
			var type = memoryCache.getFieldType(id); 
	        fields[id] = new SimpleField(
	    		{
	    			:x => coord[i][0],
	    			:y => coord[i][1],
	    			:h => h,
	    			:w => w,
	    			:type =>type,
	    			:id => id,
					:fontId =>  memoryCache.getFontByFieldType(type),
	    			:justify => Graphics.TEXT_JUSTIFY_CENTER
	    		}
	    	);
		}


		///////////////////////////////////////////////////////////////////////
		//DATA FIELDS
		h = 22;
		y = fields[:time].y+fields[:time].h;
		x = fields[:time].x - h;
		memoryCache.setBackgroundY(1, y);

		var wPicture = h;
		var wText = (System.getDeviceSettings().screenWidth - 2*x - 3*wPicture)/3;

		coord = new [FIELDS_COUNT];
		coord[0] = [x,y];
		coord[1] = [x+(wPicture+wText),y];
		coord[2] = [x+2*(wPicture+wText),y];
		coord[3] = [x,y + h];
		coord[4] = [x+(wPicture+wText),y + h];
		coord[5] = [x+2*(wPicture+wText),y + h];

		for (var i = 0; i < FIELDS_COUNT; i++){

			var idPicture = "P"+i;
	        var id = "F"+i;

	        fields[idPicture] = new SimpleField(
	    		{
	    			:x => coord[i][0],
	    			:y => coord[i][1],
	    			:h => h,
	    			:w => wPicture,
	    			:type => memoryCache.getPictureType(id),
	    			:id => id,
					:fontId => :picture,
	    			:justify => Graphics.TEXT_JUSTIFY_CENTER
	    		}
	    	);

	        fields[id] = new SimpleField(
	    		{
	    			:x => coord[i][0] + wPicture,
	    			:y => coord[i][1],
	    			:h => h,
	    			:w => wText,
	    			:type => memoryCache.getFieldType(id),
	    			:id => id,
					:fontId => :small,
	    			:justify => Graphics.TEXT_JUSTIFY_LEFT
	    		}
	    	);
		}

		///////////////////////////////////////////////////////////////////////
		//WEATHER
		var fromPictureToTemp = 5;
		h = fields["F0"].h*2;
		w = h;
        fields[:weather_picture] = new SimpleField(
    		{
    			:x => coord[0][0],
    			:y => fields[:date].y - h,
    			:h => h,
    			:w => w-fromPictureToTemp,
    			:type => :weather_picture,
    			:id => :weather,
    			:fontId => :weather,
    			:justify => Graphics.TEXT_JUSTIFY_CENTER
    		}
    	);

        fields[:weather_temp] = new SimpleField(
    		{
    			:x => fields[:weather_picture].x + fields[:weather_picture].w,
    			:y => fields[:weather_picture].y,
    			:h => h,
    			:w => w+fromPictureToTemp,
    			:type => :weather_temp,
    			:id => :weather,
    			:fontId => :medium,
    			:justify => Graphics.TEXT_JUSTIFY_CENTER
    		}
    	);

		h = fields[:weather_temp].h/2;
		w = h;
        fields[:weather_wind_dir] = new WindDirectionField(
    		{
    			:x => fields[:weather_temp].x + fields[:weather_temp].w,
    			:y => fields[:weather_temp].y,
    			:h => h,
    			:w => w,
    			:type => :weather_wind_dir,
    			:id => :weather,
    			:fontId => :small,
    			:justify => Graphics.TEXT_JUSTIFY_CENTER
    		}
    	);

        fields[:weather_wind_speed] = new SimpleField(
    		{
    			:x => fields[:weather_wind_dir].x + fields[:weather_wind_dir].w,
    			:y => fields[:weather_wind_dir].y,
    			:h => h,
    			:w => fields["F0"].w*0.6,
    			:type => :weather_wind_speed,
    			:id => :weather,
    			:fontId => :small,
    			:justify => Graphics.TEXT_JUSTIFY_LEFT
    		}
    	);

        fields[:weather_wind_speed_unit] = new SimpleField(
    		{
    			:x => fields[:weather_wind_dir].x,
    			:y => fields[:weather_wind_dir].y + fields[:weather_wind_dir].h,
    			:h => fields[:weather_temp].h - fields[:weather_wind_dir].h,
    			:w => fields[:weather_wind_dir].w + fields[:weather_wind_speed].w,
    			:type => :weather_wind_speed_unit,
    			:id => :weather,
    			:fontId => :small,
    			:justify => Graphics.TEXT_JUSTIFY_CENTER
    		}
    	);
		
		if ( Application.Properties.getValue("WShowHumPr")){
	        fields[:weather_hum_picture] = new SimpleField(
	    		{
	    			:x => fields[:weather_wind_speed].x+fields[:weather_wind_speed].w,
	    			:y => fields[:weather_wind_speed].y,
	    			:h => fields["P0"].h,
	    			:w => fields["P0"].w,
	    			:type => :weather_hum_picture,
	    			:id => :weather,
	    			:fontId => :picture,
	    			:justify => Graphics.TEXT_JUSTIFY_CENTER
	    		}
	    	);
	
	        fields[:weather_pressure_picture] = new SimpleField(
	    		{
	    			:x => fields[:weather_hum_picture].x,
	    			:y => fields[:weather_hum_picture].y + fields[:weather_hum_picture].h,
	    			:h => fields[:weather_hum_picture].h,
	    			:w => fields[:weather_hum_picture].w,
	    			:type => :weather_pressure_picture,
	    			:id => :weather,
	    			:fontId => :picture,
	    			:justify => Graphics.TEXT_JUSTIFY_CENTER
	    		}
	    	);
	
	         fields[:weather_hum] = new SimpleField(
	    		{
	    			:x => fields[:weather_hum_picture].x+fields[:weather_hum_picture].w,
	    			:y => fields[:weather_hum_picture].y,
	    			:h => fields["F0"].h,
	    			:w => fields["F0"].w,
	    			:type => :weather_hum,
	    			:id => :weather,
	    			:fontId => :small,
	    			:justify => Graphics.TEXT_JUSTIFY_LEFT
	    		}
	    	);
	
	        fields[:weather_pressure] = new SimpleField(
	    		{
	    			:x => fields[:weather_hum].x,
	    			:y => fields[:weather_hum_picture].y+fields[:weather_hum_picture].h,
	    			:h => fields[:weather_hum].h,
	    			:w => fields[:weather_hum].w,
	    			:type => :weather_pressure,
	    			:id => :weather,
	    			:fontId => :small,
	    			:justify => Graphics.TEXT_JUSTIFY_LEFT
	    		}
	    	);
		}else{//dont show pressure and hummidity
			var shiftX = (dc.getWidth() - fields[:weather_picture][:x] - fields[:weather_wind_speed_unit][:x] - fields[:weather_wind_speed_unit][:w])/2;
			fields[:weather_picture][:x] += shiftX; 
			fields[:weather_temp][:x] += shiftX;
			fields[:weather_wind_dir][:x] += shiftX; 
			fields[:weather_wind_speed][:x] += shiftX; 
			fields[:weather_wind_speed_unit][:x] += shiftX;
		
		}
		///////////////////////////////////////////////////////////////////////
		//BATTERY
		h = fields["F0"].h;
		w = fields["F0"].w;
        fields[:battery_picture] = new BatteryField(
    		{
    			:x => System.getDeviceSettings().screenWidth/2-w,
    			:y => fields[:weather_picture].y -h,
    			:h => h,
    			:w => w,
    			:type => :battery_picture,
    			:id => :battery,
    			:fontId => :small,
    			:justify => Graphics.TEXT_JUSTIFY_LEFT
    		}
    	);

        fields[:battery] = new SimpleField(
    		{
    			:x => System.getDeviceSettings().screenWidth/2,
    			:y => fields[:battery_picture].y,
    			:h => h,
    			:w => w,
    			:type => :battery,
    			:id => :battery,
    			:fontId => :small,
    			:justify => Graphics.TEXT_JUSTIFY_LEFT
    		}
    	);

		///////////////////////////////////////////////////////////////////////
		//Moon phase

    	 fields[:moon] = new SimpleField(
    		{
    			:x => (System.getDeviceSettings().screenWidth - fields[:weather_picture].h)/2,
    			:y => fields["F5"].y + fields["F5"].h,
    			:h => fields[:weather_picture].h,
    			:w => fields[:weather_picture].w,
    			:type => :moon,
    			:id => :moon,
    			:fontId => :weather,
    			:justify => Graphics.TEXT_JUSTIFY_CENTER
    		}
    	);


    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
       	var location = Activity.getActivityInfo().currentLocation;
    	if (location != null) {
			location = location.toDegrees();
			Application.Storage.setValue("Lat", location[0].toFloat());
			Application.Storage.setValue("Lon", location[1].toFloat());
		} else {
			if (Application.Storage.getValue("Lat") == null || Application.Storage.getValue("Lon") == null){
				if ( Toybox has :Weather){
					location = Toybox.Weather.getCurrentConditions().observationLocationPosition;
			    	if (location != null) {
						location = location.toDegrees();
						Application.Storage.setValue("Lat", location[0].toFloat());
						Application.Storage.setValue("Lon", location[1].toFloat());
					}
				}
			}
		}
    	Application.getApp().registerEvents();
    }

	function drawBackground(dc){
		var bColors = memoryCache.settings[:colors];
		var backgroundSettings = [
			[0, memoryCache.backgroundY[0], bColors[:background1]],
			[memoryCache.backgroundY[0],memoryCache.backgroundY[1] - memoryCache.backgroundY[0],bColors[:background2]],
			[memoryCache.backgroundY[1],System.getDeviceSettings().screenHeight - memoryCache.backgroundY[1],bColors[:background3]],
		];
		var w = System.getDeviceSettings().screenWidth;
		for (var i = 0; i < 3; i++){
			dc.setColor( backgroundSettings[i][2], backgroundSettings[i][2]);
			dc.setClip(0, backgroundSettings[i][0], w, backgroundSettings[i][1]);
			dc.fillRectangle(0, backgroundSettings[i][0], w, backgroundSettings[i][1]);
		}
	}

    // Update the view
    function onUpdate(dc) {
		
		//Set day naght presets
		if (memoryCache.settings[:switchDayNight]){
			var sunrise = Tools.getSunEvent(SUNRISE, false);
			var sunset = Tools.getSunEvent(SUNSET, false);
			if (sunrise != null && sunset != null){
				var now = Time.now();
				var isNight = true;
				if(now.greaterThan(sunrise) && now.lessThan(sunset)){
					isNight = false;
				}
				
				if (memoryCache.oldValues[:isNight] != isNight){
					var idSettings = StorageSettings.getPeriodicSettingsId(isNight ? STORAGE_KEY_NIGHT : STORAGE_KEY_DAY);
					if (idSettings != null){
						StorageSettings.load(idSettings);
					}
					memoryCache.oldValues[:isNight] = isNight;
				}
			}
		}else{//dont switch day/night
			if (memoryCache.oldValues[:isStarted] != true){
				var idSettings = StorageSettings.getPeriodicSettingsId(STORAGE_KEY_GLOBAL);
				if (idSettings != null){
					StorageSettings.load(idSettings);
				}			
			}
		}
		
		if (memoryCache.oldValues[:isStarted] != true){
			createFields(dc);
			drawBackground(dc);
			memoryCache.oldValues[:isStarted] = false;
		}

		memoryCache.checkWeatherActuality();
		var ids = fields.keys();
		for (var i = 0; i < ids.size(); i++){

			var fieldId = ids[i];
			var oldValue = memoryCache.oldValues[fieldId];
			var value = Data.getValueByFieldType(fields[fieldId].type, oldValue);

			//Danger place.
			var needUpdate = false;
			if(value == null){
				needUpdate = (value != oldValue);
			}else if(value has :equals){
				needUpdate = !value.equals(oldValue);
			}else{
				needUpdate = (value != oldValue);
			}

			if (needUpdate){
				fields[fieldId].draw(dc, value);
				memoryCache.oldValues[fieldId] = value;
			}
		}

		memoryCache.oldValues[:isStarted] = true;
		dc.setClip(0, 0, 0, 0);//fix bug Vivoactive 4
    }

	function onPartialUpdate(dc){

		if (memoryCache.everySecondFields.size()>0){
			for (var i = 0; i < memoryCache.everySecondFields.size(); i++){
				var fieldId = memoryCache.everySecondFields[i];
				var oldValue = memoryCache.oldValues[fieldId];
				var value = getValueByFieldType(fields[fieldId].type, oldValue);
				if (!value.equals(oldValue)){
					fields[fieldId].draw(dc, value);
					memoryCache.oldValues[fieldId] = value;
				}
			}
		}
	}

    function onHide() {
    	memoryCache = new MemoryCache();
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    	memoryCache = new MemoryCache();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
}
