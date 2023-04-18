defmodule ThumbHash do
  @moduledoc """
  A bridge to the Rust ThumbHash library.
  See: https://github.com/evanw/thumbhash for original implmentation.
  """

  use Rustler, otp_app: :thumb_hash

  @doc """
  Takes rgba data as a binary in u8 rgba format flattened with 4 values per pixel.
  e.g. <<r1 g1 b1 a1 r2 g2 b2 a2 ...>>
  Returns a list of integer values that make up thumbhash of the image
  Images must be pre-scaled to fit within a 100px x 100px bounding box.
  """
  def rgba_to_thumb_hash(_width, _height, _rgba), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Generates a base64 encoded thumbhash of the image located at `path`
  """
  def generate_base64_hash!(path) do
    thumbnail =
      path
      |> Image.open!()
      |> Image.thumbnail!(100, export_icc_profile: :srgb)

    alpha = Image.new!(Image.width(thumbnail), Image.height(thumbnail), bands: 1, color: 255)

    {:ok, tensor} =
      thumbnail
      |> Image.add_alpha!(alpha)
      |> Vix.Vips.Image.write_to_tensor()

    %{data: data, shape: {w, h, 4}, names: [:width, :height, :bands], type: {:u, 8}} = tensor
    hash = rgba_to_thumb_hash(w, h, data)
    hashbin = Enum.into(hash, <<>>, fn int -> <<int::8>> end)
    Base.encode64(hashbin)
  end
end
