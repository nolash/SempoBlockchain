export interface Organisation {
  name: string
}
export const UPDATE_ORGANISATIONS = "UPDATE_ORGANISATIONS";
interface UpdateOrganisations {
  type: typeof UPDATE_ORGANISATIONS,
  organisations: Organisation[]
}

export type OrganisationAction = UpdateOrganisations

export const LOAD_ORGANISATION_REQUEST = "LOAD_ORGANISATIONS_REQUEST";
interface LoadOrganisationRequest {
  type: typeof LOAD_ORGANISATION_REQUEST,
  id: string
}
export const LOAD_ORGANISATION_SUCCESS = "LOAD_ORGANISATIONS_SUCCESS";
interface LoadOrganisationSuccess {
  type: typeof LOAD_ORGANISATION_SUCCESS,
}
export const LOAD_ORGANISATION_FAILURE = "LOAD_ORGANISATIONS_FAILURE";
interface LoadOrganisationFailure {
  type: typeof LOAD_ORGANISATION_FAILURE,
  error: string
}

export type LoadOrganisationAction = LoadOrganisationRequest | LoadOrganisationSuccess | LoadOrganisationFailure
