namespace JsonRPC2;

class Error implements Err {

	protected _err;

	public function __construct(string err) {

		let this->_err = err;
	}

	public function Error() -> string {

		return this->_err;
	}
}