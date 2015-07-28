defmodule JsonWebToken.JwtTest do
  use ExUnit.Case

  alias JsonWebToken.Jwt

  doctest Jwt

  @hs256_key "gZH75aKtMN3Yj0iPS4hcgUuTwjAzZr9C"
  @claims %{iss: "joe", exp: 1300819380, "http://example.com/is_root": true}

  test "sign/2 w default alg (HS256) does verify/2" do
    jwt = Jwt.sign(@claims, %{key: @hs256_key})
    assert @claims === Jwt.verify(jwt, %{key: @hs256_key})
  end

  test "sign/2 w explicit alg does verify/2" do
    opts = %{alg: "HS256", key: @hs256_key}
    jwt = Jwt.sign(@claims, opts)
    assert @claims === Jwt.verify(jwt, opts)
  end

  test "sign/2 w alg nil does verify/2" do
    opts = %{alg: nil, key: @hs256_key}
    jwt = Jwt.sign(@claims, opts)
    assert @claims === Jwt.verify(jwt, opts)
  end

  test "sign/2 w alg empty string does verify/2" do
    opts = %{alg: "", key: @hs256_key}
    jwt = Jwt.sign(@claims, opts)
    assert @claims === Jwt.verify(jwt, opts)
  end

  test "sign/2 w alg 'none' does verify/2" do
    opts = %{alg: "none"}
    jwt = Jwt.sign(@claims, opts)
    assert @claims === Jwt.verify(jwt, opts)
  end

  test "sign/2 w claims nil raises" do
    message = "Claims nil"
    assert_raise RuntimeError, message, fn ->
      Jwt.sign(nil, key: @hs256_key)
    end
  end

  test "sign/2 w claims empty string raises" do
    message = "Claims blank"
    assert_raise RuntimeError, message, fn ->
      Jwt.sign("", key: @hs256_key)
    end
  end

  test "config_header/1 w key, w/o alg returns default alg and filters key" do
    assert Jwt.config_header(key: @hs256_key) == %{typ: "JWT", alg: "HS256"}
  end

  test "config_header/1 w key, w alg returns alg and filters key" do
    assert Jwt.config_header(alg: "RS256", key: "rs_256_key") == %{typ: "JWT", alg: "RS256"}
  end

  test "config_header/1 w key, w alg empty string returns default alg" do
    assert Jwt.config_header(alg: "", key: @hs256_key) == %{typ: "JWT", alg: "HS256"}
  end

  test "config_header/1 w key, w alg nil returns default alg" do
    assert Jwt.config_header(alg: nil, key: @hs256_key) == %{typ: "JWT", alg: "HS256"}
  end

  test "config_header/1 w/o key, w alg 'none'" do
    assert Jwt.config_header(alg: "none") == %{typ: "JWT", alg: "none"}
  end
end
