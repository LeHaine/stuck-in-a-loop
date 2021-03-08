package tools;

@:generic
class State<T> {

	private var machine: StateMachine<T>;
	private var context: T;

	public function new() {}

	public function setMachineAndContext(machine: StateMachine<T>, context: T) {
		this.machine = machine;
		this.context = context;
		onInitialized();
	}

	public function onInitialized() {}

	public function reason(): Bool {
		return false;
	}

	public function update(tmod: Float) {}

	public function begin() {}

	public function end() {}
}
