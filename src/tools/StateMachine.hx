package tools;

@:generic
final class StateMachine<T> {

	private var context: T;

	public var onStateChanged: Null<(String) -> Void>;
	public var currentState: State<T>;

	private final _states: Array<State<T>> = [];
	private final _stateNames: Array<String> = [];

	public function new(context: T) {
		this.context = context;
	}

	/**
	 * Add a new state to the FSM. States are prioritized from first added to last added.
	 * @param state the state to add
	 */
	public function addState(state: State<T>) {
		state.setMachineAndContext(this, context);
		_states.push(state);
		_stateNames.push(Type.getClassName(Type.getClass(state)));
	}

	public function update(tmod: Float) {
		for (i in 0..._states.length) {
			var state = _states[i];
			var stateName = _stateNames[i];
			if (state.reason()) {
				if (currentState != state) {
					if (currentState != null) {
						currentState.end();
					}
					currentState = state;
					currentState.begin();
					if (onStateChanged != null) {
						onStateChanged(stateName);
					}
				}
				currentState.update(tmod);
				return;
			}
		}
	}
}
