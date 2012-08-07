package mulunka.logging {
	public function warn(...args : Array) {
		trace("[WARN]", args.join(" "));
	}
}
