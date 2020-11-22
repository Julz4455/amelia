defmodule Amelia.Codes do
  def ok, do: 200
  def created, do: 201
  def empty, do: 204
  def field_error, do: 400
  def unauthorized, do: 401
  def not_found, do: 404
  def teapot, do: 418
end
