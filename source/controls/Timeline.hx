package controls;

import haxe.Rest;
import haxe.Timer;

class Timeline {
    public static function timeline(timeline:Rest<Array<Dynamic>>) {
        function start(index:Int) {
            if (index > timeline.length-1)
                return;
            
            var frame = timeline[index];
            Timer.delay(()-> {
                frame[1]();
                start(index+1);
            }, Math.floor(frame[0] * 1000));

        }

        start(0);
    }
}