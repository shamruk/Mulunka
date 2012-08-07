package mulunka.logging {
	public function debug(...args : Array) : void {
		trace("[DEBUG]", args.join(" "));
	}
}
