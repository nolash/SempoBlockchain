"""
test_limits.py verifies that the transfer limits processing yields expected results
"""

import logging
import pytest

from app.server.utils import transfer_limits
from app.server import db

logging.basicConfig(level=logging.DEBUG)
logg = logging.getLogger(__name__)

def test_limit_users(create_credit_transfer):
    q = db.session.query()
    transfer_limits.not_rejected_filter(q)
    logg.debug('{}'.format(create_credit_transfer))
    for limit in transfer_limits.LIMITS:
        r = limit.apply_all_filters(create_credit_transfer, q)

#@pytest.mark.parametrize(
#        'time_period_days, no_transfer_allowed, total_amount', [
#        (7, False, 42),
#        (30, True, None),
#])
#def test_limit_different_users(time_period_days, no_transfer_allowed, total_amount):
#    limit_name = 'foo';
#    transfer_limits.TransferLimit(
#            # = TransferTypeEnum.PAYMENT,
#            applied_to_transfer_types   = transfer_limits.GENERAL_PAYMENTS,
#            application_filter          = None,
#            name                        = limit_name,
#            time_period_days            = time_period_days,
#            no_transfer_allowed         = no_transfer_allowed,
#            total_amount                = total_amount,
#            )
#    logg.debug('{} {}'.format(time_period_days, no_transfer_allowed))
#    pass
