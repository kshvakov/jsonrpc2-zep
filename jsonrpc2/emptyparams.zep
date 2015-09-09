namespace JsonRPC2;

class EmptyParams implements Params {

	public function Get() {

		return new \StdClass;
	}
}