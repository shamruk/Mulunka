package {
	import flash.utils.setTimeout;

	public function fatal(...args : Array) : void {
		var error : Error = new Error(args.toString());
		setTimeout(function () : void {
			throw error;
		}, 1);
	}
}
