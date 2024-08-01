defmodule ThumbHash do
  @moduledoc """
  A bridge to the Rust ThumbHash library.
  See: https://github.com/evanw/thumbhash for original implmentation.

  Note: a Rust toolchain is required to compile the rust deps.
  """

  use Rustler, otp_app: :thumb_hash
  alias Vix.Vips.Image, as: VixImage

  @doc """
  Takes rgba data as a binary in u8 rgba format flattened with 4 values per pixel.
  e.g. <<r1 g1 b1 a1 r2 g2 b2 a2 ...>>
  Returns a list of integer values that make up a thumbhash of the image
  Images must be pre-scaled to fit within a 100px x 100px bounding box.
  """
  @spec rgba_to_thumb_hash(non_neg_integer(), non_neg_integer(), binary()) ::
          list(byte()) | no_return()
  def rgba_to_thumb_hash(_width, _height, _rgba), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Takes a hash as a binary and returns the width, height, and image data.
  """
  @spec thumb_hash_to_rgba([byte()]) ::
          {:ok, {non_neg_integer(), non_neg_integer(), binary()}} | {:error, any()} | no_return()
  def thumb_hash_to_rgba(_b64_hash), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Generates a base64 encoded thumbhash of the image located at `path`
  """
  @spec generate_base64_hash!(Path.t()) :: binary() | no_return()
  def generate_base64_hash!(path) do
    path
    |> Image.open!()
    |> Image.thumbnail!(100, export_icc_profile: :srgb)
    |> do_generate!()
  end

  @doc """
  Generates a base64 encoded thumbhash of the image stored in `thumbnail`
  """
  @spec generate_base64_hash_from_binary!(binary()) :: binary() | no_return()
  def generate_base64_hash_from_binary!(buffer) do
    buffer
    |> Image.from_binary!()
    |> do_generate!()
  end

  defp do_generate!(thumbnail) do
    image_with_alpha =
      if Image.has_alpha?(thumbnail) do
        thumbnail
      else
        alpha = Image.new!(Image.width(thumbnail), Image.height(thumbnail), bands: 1, color: 255)
        Image.add_alpha!(thumbnail, alpha)
      end

    {:ok, tensor} = VixImage.write_to_tensor(image_with_alpha)

    %Vix.Tensor{data: data, shape: {h, w, 4}, names: [:height, :width, :bands], type: {:u, 8}} =
      tensor

    hash = rgba_to_thumb_hash(w, h, data)
    hashbin = Enum.into(hash, <<>>, fn int -> <<int::8>> end)
    Base.encode64(hashbin)
  end

  @doc """
  Generates an image from a base64-encoded `hash`
  """
  @spec generate_image!(binary()) :: VixImage.t() | no_return()
  def generate_image!(hash) do
    case generate_image(hash) do
      {:ok, img} -> img
      {:error, err} -> raise err
      err -> raise err
    end
  end

  @doc """
  Generates a base64-encoded, inline representation of an image from a
  base64-encoded `hash` in the given `format` (default: `".png"`)
  """
  @spec generate_base64_inline_image!(binary(), binary()) :: binary() | no_return()
  def generate_base64_inline_image!(hash, format \\ ".png") do
    with {:ok, img} <- generate_image(hash),
         {:ok, buf} <- VixImage.write_to_buffer(img, format) do
      Base.encode64(buf)
    else
      err -> err
    end
  end

  defp generate_image(hash) do
    with {:ok, bin} <- base64_decode_bytes(hash),
         {:ok, {w, h, data}} <- thumb_hash_to_rgba(bin) do
      rgba_to_image(data, w, h)
    else
      err -> err
    end
  end

  defp base64_decode_bytes(hash) do
    case Base.decode64(hash) do
      {:ok, bin} -> {:ok, :binary.bin_to_list(bin)}
      error -> error
    end
  end

  defp rgba_to_image(rgba, w, h) do
    rgba
    # use native endianness, see: https://hexdocs.pm/vix/Vix.Vips.Image.html#new_from_binary/5
    |> Enum.into(<<>>, &<<&1::native-unsigned-integer-8>>)
    |> VixImage.new_from_binary(w, h, 4, :VIPS_FORMAT_UCHAR)
  end
end
