import pytest
from functools import partial
from server.utils.ussd.kenya_ussd_processor import KenyaUssdProcessor

from helpers.user import UserFactory, TransferUsageFactory
from helpers.ussd_session import UssdSessionFactory, UssdMenuFactory
from server.models.ussd import UssdMenu, UssdSession

standard_user = partial(UserFactory)


def mock_get_most_relevant_transfer_usage():
    transfer_usage_1 = partial(TransferUsageFactory)
    transfer_usage_1.name = 'Food'
    transfer_usage_1.translations = {'en': 'Food', 'sw': 'Chakula'}
    transfer_usage_2 = partial(TransferUsageFactory)
    transfer_usage_2.translations = {'en': 'Education', 'sw': 'Elimu'}
    transfer_usage_2.name = 'Education'
    list_of_transfer_usage = [transfer_usage_1, transfer_usage_2]
    return list_of_transfer_usage


@pytest.mark.parametrize("menu_name, language, expected", [
    ("send_token_reason", "en", '\n1. Food\n2. Education'),
    ("send_token_reason", "sw", '\n1. Chakula\n2. Elimu'),
    ("send_token_reason", None, '\n1. Food\n2. Education'),
    ("directory_listing", "en", '\n1. Food\n2. Education'),
    ("directory_listing", "sw", '\n1. Chakula\n2. Elimu'),
    ("directory_listing", None, '\n1. Food\n2. Education'),
])
def test_replace_vars(mocker, test_client, init_database, menu_name, language, expected):
    start_state = partial(UssdSessionFactory)
    user = standard_user()
    user.preferred_language = language

    type(user).get_most_relevant_transfer_usage = mocker.PropertyMock(
        return_value=mock_get_most_relevant_transfer_usage)
    text = '''CON Random introduction text %options% 0. Back'''
    menu = partial(UssdMenuFactory)
    menu.name = menu_name
    resulting_menu = KenyaUssdProcessor.replace_vars(
        menu, start_state, text, user)

    assert '%options%' not in resulting_menu
    assert expected in resulting_menu
