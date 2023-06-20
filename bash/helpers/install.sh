update_tools() {
  echo "Updating go tools"
  golang_tools
}

golang_tools() {
  go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
  go install github.com/go-delve/delve/cmd/dlv@latest
  go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
  go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
  go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
  go install github.com/mattn/efm-langserver@latest
  go install golang.org/x/tools/gopls@latest
  go install mvdan.cc/gofumpt@latest
  go install github.com/vadimi/grpc-client-cli/cmd/grpc-client-cli@latest
  go install github.com/UltiRequiem/yamlfmt@latest
  go install github.com/cweill/gotests/gotests@latest
  go install github.com/fatih/gomodifytags@latest
  go install github.com/josharian/impl@latest
  go install github.com/haya14busa/goplay/cmd/goplay@latest
  go install golang.org/x/vuln/cmd/govulncheck@latest
  go install github.com/bufbuild/buf/cmd/buf@latest
  go install github.com/mrtazz/checkmake/cmd/checkmake@latest
}