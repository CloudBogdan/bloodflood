package controls;

class StateMachine {
    public var currentState:String = "";
    public var states:Map<String, Int> = [];
    public var onChange:String->Void = s->{};

    public function new() {}
    
    public function setState(name:String, ignorePriority:Bool=false):Bool {
        var curState = states.get(currentState);
        var nextState = states.get(name);

        if (curState != null && nextState != null) {

            if (ignorePriority ? true : (nextState >= curState)) {
                if (currentState != name)
                    onChange(name);
                currentState = name;
            } else
                return false;

        } else {
            return false;
        }

        return true;
    }
}