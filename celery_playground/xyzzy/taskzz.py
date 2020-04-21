import logging

logg = logging.getLogger()

from server import celery_app as celeree
from server import create_app, db
from server.models import User

app = create_app()
ctx = app.app_context()
ctx.push()

celeree.conf.beat_schedule = {
    'dafoo': {
        'task': 'xyzzy.taskzz.foo',
        'schedule': 1.0,
    },
}

@celeree.task
def foo():
    task = 'eth_manager.celery_tasks.create_new_blockchain_wallet'

    kwargs = {
            'wei_target_balance': 10000,
            'wei_topup_threshold': 10000,
            }

    u = db.session.query(User).execution_options(show_all=True).first()
    logg.info('user {}'.format(u))

    celeree.signature(task, kwargs=kwargs, args=None).apply_async(queue='high-priority')
