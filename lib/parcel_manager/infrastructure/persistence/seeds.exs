# Script for populating the database. You can run it as:
#
#     mix run lib/parcel_manager/infrastructure/persistence/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ParcelManager.Infrastructure.Persistence.Repo.insert!(%ParcelManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ParcelManager.Infrastructure.Persistence.Repo
alias ParcelManager.Infrastructure.Persistence.Schemas

if Mix.env() == :dev do
  for _ <- 1..100 do
    %{id: location_id} = Repo.insert!(%Schemas.Location{name: Faker.Address.PtBr.city()})

    IO.puts("Location id=#{location_id} inserted!")
  end

  IO.puts("Seeds data inserted successfully!")
end
