defmodule Lexicon.Doc do
  @moduledoc """
  A Lexicon document.
  See: https://atproto.com/specs/lexicon#interface
  """

  alias __MODULE__

  @type nsid :: String.t()

  @type t :: %__MODULE__{
          lexicon: 1,
          id: nsid(),
          # TODO: Need to confirm if revision is meant to be an integer or not.
          revision: number() | nil,
          description: String.t() | nil,
          defs: %{
            required(String.t()) =>
              Lexicon.UserType.t() | Lexicon.Array.t() | Lexicon.Primitive.t() | [Lexicon.Ref.t()]
          }
        }

  @enforce_keys [:id, :defs]
  defstruct [:id, :revision, :description, :defs, lexicon: 1]

  @user_types %{
    "array" => Lexicon.Array,
    "blob" => Lexicon.Blob,
    "boolean" => Lexicon.Boolean,
    "bytes" => Lexicon.Bytes,
    "cid-link" => Lexicon.CIDLink,
    "integer" => Lexicon.Integer,
    "object" => Lexicon.Object,
    "procedure" => Lexicon.XRPC.Procedure,
    "query" => Lexicon.XRPC.Query,
    "record" => Lexicon.Record,
    "string" => Lexicon.String,
    "subscription" => Lexicon.Subscription,
    "token" => Lexicon.Token,
    "unknown" => Lexicon.Unknown
  }

  @doc """
  Parse a Lexicon document.
  """
  @spec parse(String.t() | map() | t()) :: t()
  def parse(%Doc{} = doc), do: doc

  def parse(doc) when is_binary(doc) do
    doc
    |> Jason.decode!()
    |> parse()
  end

  def parse(%{"lexicon" => 1} = doc) do
    struct(Doc, Map.update!(doc, "defs", &parse_defs/1))
  end

  # Where `defs` is a map where the key is a `def_id` (e.g. "main") and the
  # value is a `Lexicon.UserType`.
  defp parse_defs(defs) do
    Enum.into(defs, %{}, fn {def_id, %{"type" => type} = def} ->
      {def_id, apply(@user_types[type], :parse, [def])}
    end)
  end

  @doc """
  Validate a Lexicon document.
  """
  @spec validate(t()) :: :ok | {:error, reason :: String.t()}
  def validate(%Doc{id: nsid, defs: defs}) do
    with :ok <- NSID.validate(nsid) do
      validate_defs(defs)
    end
  end

  defp validate_defs(%{} = defs) do
    Enum.reduce_while(defs, :ok, fn
      {"main", %{type: type}}, :ok when type not in ~w[record procedure query subscription] ->
        {:halt,
         {:error, "Records, procedures, queries, and subscriptions must be the main definition."}}

      {_def_id, %{type: _type}}, :ok ->
        {:cont, :ok}
    end)
  end
end
