package {
	public function fatal(...args : Array) : void {
		throw args.join(", ");
	}
}
