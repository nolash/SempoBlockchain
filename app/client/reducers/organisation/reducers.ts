import {combineReducers} from "redux";
import {
  LOAD_ORGANISATION_REQUEST,
  UPDATE_ORGANISATIONS,
  LOAD_ORGANISATION_SUCCESS,
  LOAD_ORGANISATION_FAILURE,
  LoadOrganisationAction, OrganisationAction, Organisation
} from "./types";

const organisations = (state = [], action: OrganisationAction): Organisation[] => {
  switch (action.type) {
    case UPDATE_ORGANISATIONS:
      return action.organisations;

    default:
      return state;
  }
};

export interface LoadOrganisationState {
  isRequesting: boolean,
  error?: string,
  success: boolean
}
const initialLoadStatusState: LoadOrganisationState = {
  isRequesting: false,
  success: false
};
const loadStatus = (state = initialLoadStatusState, action: LoadOrganisationAction): LoadOrganisationState => {
  switch (action.type) {
    case LOAD_ORGANISATION_REQUEST:
      return {...state, isRequesting: true};

    case LOAD_ORGANISATION_SUCCESS:
      return {...state, isRequesting: false, success: true};

    case LOAD_ORGANISATION_FAILURE:
      return {...state, isRequesting: false, error: action.error};

    default:
      return state;
  }
};

//@ts-ignore
export const OrganisationReducer = combineReducers({
  organisations,
  loadStatus,
});
