defmodule PDS.XRPC.APIController do
  use PDS.XRPC, :controller

  # {
  #   "lexicon": 1,
  #   "id": "com.atproto.repo.listRecords",
  #   "defs": {
  #     "main": {
  #       "type": "query",
  #       "description": "List a range of records in a collection.",
  #       "parameters": {
  #         "type": "params",
  #         "required": [
  #           "repo",
  #           "collection"
  #         ],
  #         "properties": {
  #           "repo": {
  #             "type": "string",
  #             "format": "at-identifier",
  #             "description": "The handle or DID of the repo."
  #           },
  #           "collection": {
  #             "type": "string",
  #             "format": "nsid",
  #             "description": "The NSID of the record type."
  #           },
  #           "limit": {
  #             "type": "integer",
  #             "minimum": 1,
  #             "maximum": 100,
  #             "default": 50,
  #             "description": "The number of records to return."
  #           },
  #           "cursor": {
  #             "type": "string"
  #           },
  #           "rkeyStart": {
  #             "type": "string",
  #             "description": "DEPRECATED: The lowest sort-ordered rkey to start from (exclusive)"
  #           },
  #           "rkeyEnd": {
  #             "type": "string",
  #             "description": "DEPRECATED: The highest sort-ordered rkey to stop at (exclusive)"
  #           },
  #           "reverse": {
  #             "type": "boolean",
  #             "description": "Reverse the order of the returned records?"
  #           }
  #         }
  #       },
  #       "output": {
  #         "encoding": "application/json",
  #         "schema": {
  #           "type": "object",
  #           "required": [
  #             "records"
  #           ],
  #           "properties": {
  #             "cursor": {
  #               "type": "string"
  #             },
  #             "records": {
  #               "type": "array",
  #               "items": {
  #                 "type": "ref",
  #                 "ref": "#record"
  #               }
  #             }
  #           }
  #         }
  #       }
  #     },
  #     "record": {
  #       "type": "object",
  #       "required": [
  #         "uri",
  #         "cid",
  #         "value"
  #       ],
  #       "properties": {
  #         "uri": {
  #           "type": "string",
  #           "format": "at-uri"
  #         },
  #         "cid": {
  #           "type": "string",
  #           "format": "cid"
  #         },
  #         "value": {
  #           "type": "unknown"
  #         }
  #       }
  #     }
  #   }
  # }
  def query(conn, %{"id" => "com.atproto.repo.listRecords"} = lex) do
    IO.inspect(lex["defs"])
    # ...

    doc = Lexicon.Doc.parse(lex)

    send_resp(conn, 200, "OK")
  end
end
