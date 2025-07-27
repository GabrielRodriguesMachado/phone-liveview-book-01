# phone-liveview-book-01

Then configure your database in config/dev.exs and run:
```
mix ecto.create
```

Start your Phoenix app with:
```
mix phx.server
```

You can also run your app inside IEx (Interactive Elixir) as:
```
iex -S mix phx.server
```

iex usefull comands

print the public functions of a context
```elixir
iex> alias Pentos.Accounts
iex> exports Accounts
apply_user_email/3                 change_user_email/1                change_user_email/2
change_user_password/1             change_user_password/2
...
```
