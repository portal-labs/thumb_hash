defmodule ThumbHashTest do
  use ExUnit.Case
  doctest ThumbHash

  test "generates a hash of an image" do
    waves = Path.join(__DIR__, "waves.jpg")
    waves_hash = "b8cJJIpJdnZaeIiQho1pf6b3Vg=="
    assert ThumbHash.generate_base64_hash!(waves) == waves_hash
  end

  test "generates a hash of an image with an alpha channel" do
    alpha_image = Path.join(__DIR__, "with-alpha.png")
    hash = "EmmOI4gPgod/h5egexP4ZwAAh4d3eIg="
    assert ThumbHash.generate_base64_hash!(alpha_image) == hash
  end
end
