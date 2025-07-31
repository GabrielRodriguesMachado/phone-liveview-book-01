defmodule PentoWeb.WrongLive do
  require Logger
  use PentoWeb, :live_view

  def mount(_params, session, socket) do
    {:ok,
     assign(socket,
       score: 0,
       message: "Make a guess:",
       time: time(),
       session_id: session["live_socket_id"]
     )}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    case assigns.live_action do
      :play ->
        ~H"""
        <h1 class="mb-4 text-4xl font-extrabold">Your score: {@score}</h1>
        <h2>
          {@message}
          It's {@time}
        </h2>
        <br />
        <h2>
          <%= for n <- 1..10 do %>
            <.link
              class="bg-blue-500 hover:bg-blue-700
        text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
              phx-click="guess"
              phx-value-number={n}
            >
              {n}
            </.link>
          <% end %>
        </h2>
        <br />
        <pre>
          {@current_user.email}
          {@session_id}
        </pre>
        """

      :win ->
        ~H"""
        <h1 class="mb-4 text-4xl font-extrabold">
          You win!
        </h1>
        <button
          class="bg-orange-500 hover:bg-orange-600 text-white font-bold py-3 px-6 rounded-full transition-all duration-300 shadow-lg hover:shadow-xl hover:-translate-y-1 active:translate-y-0"
          phx-click="play_again"
        >
          🔄 Play again
        </button>
        """
    end
  end

  def time, do: DateTime.utc_now() |> to_string()

  def generate_random(min_val, max_val), do: :rand.uniform(max_val - min_val + 1)

  def handle_event("play_again", _params, socket) do
    {
      :noreply,
      push_patch(socket, to: ~p"/guess")
    }
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    correct = generate_random(1, 10)

    case String.to_integer(guess) == correct do
      true ->
        {
          :noreply,
          push_patch(socket, to: ~p"/guess/win")
        }

      false ->
        message = "You guess: #{guess}. Wrong. Guess again. "
        score = socket.assigns.score - 1

        {
          :noreply,
          assign(
            socket,
            message: message,
            score: score,
            time: time()
          )
        }
    end
  end
end
