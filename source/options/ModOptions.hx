package options;

import flixel.FlxG;
import flixel.util.FlxSave;
import sys.FileSystem;

using StringTools;

class ModOptions extends BaseOptionsMenu
{
    var optionMap:Map<String, Array<Option>> = [];

    public function new()
    {
        title = 'Mod Options';
		rpcTitle = 'Mod Options Menu'; //for Discord Rich Presence

        var luaOptionDirs:Array<String> = Paths.getModDirectories();
        luaOptionDirs.insert(0, '');

        for (i in 0...luaOptionDirs.length)
        {
            var curMod:String = luaOptionDirs[i];

            var directory:String = 'mods/' + curMod + '/options';
            if (luaOptionDirs[i] == '') {
                directory = 'mods/options';
            }

            var optionsArray:Array<Option> = [];

            if (FileSystem.exists(directory)) {
                for (file in FileSystem.readDirectory(directory))
                {
                    var path = haxe.io.Path.join([directory, file]);
                    var save:FlxSave = new FlxSave();
                    save.bind('options', curMod == '' ? 'psychenginemods' : 'psychenginemods/$curMod');

					if (!FileSystem.isDirectory(path) && file.endsWith('.txt')) {

						var optionText:Array<Dynamic> = CoolUtil.coolTextFile(path);
                        var optionType:String = optionText[3];
                        var defVal:Dynamic = Reflect.field(save.data, optionText[2]);
                        var options:String = optionText[5];
                        var optList:Array<String> = (optionType == 'string') ? options.split(',') : null;

                        if (defVal == null) {defVal = optionText[4];};

                        var option:Option = new Option( // overriding options
                            optionText[0], // name
                            optionText[1], // description
                            optionText[2], // save (a key in which optionText info is stored)
                            optionType, // optionText type
                            defVal, // default value (might be overwritten depending on what did you set)
                            optList,
                            true // other values (if it's a string option type)
                        );
                        
                        if (optionType == 'int' || optionType == 'float' || optionType == 'percent') {
                            option.displayFormat = '%v';
                            option.minValue = optionText[5];
                            option.maxValue = optionText[6];
                            option.changeValue = optionText[7];
                            option.scrollSpeed = optionText[8];
                        };

                        optionsArray.push(option);
                        addOption(option);
					};
                };
            };

            if (optionsArray.length > 0) {
                optionMap.set(curMod, optionsArray);
            }
        };

        super();
    }

    override function closeState() {
        for (map in optionMap.keys()) {
            var save:FlxSave = new FlxSave();
            var dir = map == '' ? 'psychenginemods' : 'psychenginemods/$map/';

		    save.bind('options', dir);

            for (option in optionMap.get(map)) {
                Reflect.setField(save.data, option.getVariable(), option.getValue());
            }
            save.flush();
        }
        
        super.closeState();
    };
}