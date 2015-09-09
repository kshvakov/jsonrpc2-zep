package main

import (
	"github.com/kshvakov/jsonrpc2"
	"github.com/kshvakov/jsonrpc2/server"
	"net/http"
)

type testService struct{}

func (t *testService) EmptyParams(_ *jsonrpc2.EmptyParams) (interface{}, error) {

	return "EmptyParams", nil
}

type TestSumParam struct {
	A, B int
}

func (t *TestSumParam) IsValid() bool {

	return true
}

type TestSumResult struct {
	Result int
}

func (t *testService) Sum(param *TestSumParam) (*TestSumResult, error) {

	return &TestSumResult{
		Result: param.A + param.B,
	}, nil
}

func main() {

	app := server.New()
	app.RegisterObject("Test", &testService{})

	http.ListenAndServe("127.0.0.1:9009", app)
}
