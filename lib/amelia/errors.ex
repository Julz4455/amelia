defmodule Amelia.Errors do

  def gen_missing, do: %{code: "REQUIRED_FIELD", message: "This field is required."}
  def gen(value, opts \\ []) do
    password = Keyword.get(opts, :password, false)
    max_len = Keyword.get(opts, :max_len)
    min_len = Keyword.get(opts, :min_len)
    capture = Keyword.get(opts, :capture)
    type = Keyword.get(opts, :type)
    ax = Keyword.get(opts, :ax)

    password_error = if password, do: e_password(value)
    capture_error = e_capture(value, capture, ax, type)
    min_error = e_min(value, min_len)
    max_error = e_max(value, max_len)

    [password_error, capture_error, min_error, max_error]
    |> Enum.filter(&(&1 != nil))
    |> List.flatten
  end

  defp e_password(value) do
    digits = ~r/[0-9]+/
    lowers = ~r/[a-z]+/
    uppers = ~r/[A-Z]+/
    if !is_bitstring(value) || !((value =~ lowers) and (value =~ uppers) and (value =~ digits)) do
      %{
        code: "BAD_PASSWORD",
        message: "A password must contain at least one digit, one uppercase character, and one lowercase character."
      }
    end
  end

  defp e_capture(value, capture, ax, type) do
    if capture != nil && !capture.(value) do
      %{
        code: "INVALID_VALUE",
        message: "Field must be #{if ax == 0, do: "", else: if ax == 1, do: "a", else: "an"} #{type}."
      }
    end
  end

  defp e_min(value, min_len) do
    if min_len != nil && is_bitstring(value) && String.length(value) <= min_len do
      %{
        code: "MIN_LENGTH",
        message: "Field must be #{min_len} characters or more in length."
      }
    end
  end

  defp e_max(value, max_len) do
    if max_len != nil && is_bitstring(value) && String.length(value) >= max_len do
      %{
        code: "MAX_LENGTH",
        message: "Field must be less than #{max_len} characters in length."
      }
    end
  end
end
