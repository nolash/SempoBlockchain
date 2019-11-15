import React from "react";
import {InjectedFormProps, reduxForm} from "redux-form";

export interface IOrganisationSettings {

}

interface Props {

}

class OrganisationSettingForm extends React.Component<InjectedFormProps<IOrganisationSettings, Props> & Props> {
  render() {
    //TODO(org): Set default token for organisation as window.CURRENCY_NAME
    return <form onSubmit={this.props.handleSubmit}>
      <div>TODO(org): Default token</div>
      <div>TODO(org): Custom Welcome message key</div>
      <div>TODO(org): require transfer card exists</div>
      <div>TODO(org): Default country code</div>
    </form>
  }

}

export default reduxForm({
  form: 'organisationSettings',
//@ts-ignore
})(OrganisationSettingForm);
