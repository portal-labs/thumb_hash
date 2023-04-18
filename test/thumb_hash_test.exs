defmodule ThumbHashTest do
  use ExUnit.Case
  doctest ThumbHash

  test "generates a hash of an image" do
    waves = Path.join(__DIR__, "waves.jpg")
    waves_hash = "b8cJJIpJdnZaeIiQho1pf6b3Vg=="
    assert ThumbHash.generate_base64_hash!(waves) == waves_hash
  end
end
