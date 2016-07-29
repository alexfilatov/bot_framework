defmodule BotFramework.Controller do
  @moduledoc '''
  must use Phoenix.Controller
  following functions must be defined in the module
  handle_activity(%Activity{})
  handle_message(String)
  '''
  defmacro __using__(_) do
    quote do
      alias BotFramework.{Client}
      alias BotFramework.Models.{Activity}

      def handle_activity(conn, params) do
        {:ok, activity} = params |> Activity.parse

        res = case activity.type do
          "message" -> handle_message(activity.text)
          _ -> handle_activity(activity)
        end

        Client.send_message(activity, res)

        json(conn, %{message: "Success"})
      end
    end
  end
end