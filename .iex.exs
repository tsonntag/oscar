import Ecto.Query
import Ecto.Adapters.SQL, only: [to_sql: 3]
alias Ecto.Changeset

alias Oscar.Board, as: B
alias Oscar.Canvas, as: C
alias Oscar.Repo
