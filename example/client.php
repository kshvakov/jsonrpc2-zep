<?php 

class Params implements \JsonRPC2\Params{

	public function Get() {

		return ['A' => 42, 'B' => 1];
	}
}

class Result implements \JsonRPC2\Result {

	protected $_result;

	public function Set($result) {

		$this->_result = $result;
	}
}

class Balancer implements \JsonRPC2\Balancer{

	protected $_addrasses;

	protected static $_counter;

	public function __construct(array $addresses) {

		$this->_addrasses = $addresses;

		$this->_counter   = 0;
	}

	public function Get() {

		if ($this->_counter > count($this->_addrasses)-1) {

			$this->_counter = 0;
		}

		$address = $this->_addrasses[$this->_counter];

		$this->_counter++;

		return $address;
	}

	public function Len() {

		return count($this->_addrasses);
	}
}

$client = new \JsonRPC2\Client(new Balancer(['http://127.0.0.1:9008', 'http://127.0.0.1:8080/login/', 'http://127.0.0.1:9009', 'http://127.0.0.1:8080']));

$result = new Result();

$err = $client->Send("Test.Sum", new Params(), $result);

if ($err instanceof \JsonRPC2\NillError) {

	var_dump($result);

} else {

	var_dump($err);
}


$err = $client->Send("Test.EmptyParams", new \JsonRPC2\EmptyParams(), $result);

if ($err instanceof \JsonRPC2\NillError) {

	var_dump($result);

} else {

	var_dump($err);
}
