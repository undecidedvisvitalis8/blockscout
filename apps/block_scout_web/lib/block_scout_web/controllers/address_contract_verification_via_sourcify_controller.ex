defmodule BlockScoutWeb.AddressContractVerificationViaSourcifyController do
  use BlockScoutWeb, :controller

  alias BlockScoutWeb.AddressContractVerificationController, as: VerificationController
  alias Explorer.Chain.SmartContract
  alias Explorer.ThirdPartyIntegrations.Sourcify

  def new(conn, %{"address_id" => address_hash_string}) do
    case Sourcify.check_by_address(address_hash_string) do
      {:ok, _verified_status} ->
        VerificationController.get_metadata_and_publish(address_hash_string, conn)
        redirect(conn, to: address_path(conn, :show, address_hash_string))

      _ ->
        changeset =
          SmartContract.changeset(
            %SmartContract{address_hash: address_hash_string},
            %{}
          )

        render(conn, "new.html", changeset: changeset, address_hash: address_hash_string)
    end
  end
end