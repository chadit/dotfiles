vault_list_policy_details_by_name() {
  local name="$1"
  echo "vault policy list | grep '$name' | xargs -I{} vault policy read {}"
  vault policy list | grep $name | xargs -I{} vault policy read {}
}