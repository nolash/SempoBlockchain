#!/usr/bin/python

# submits a single task to the high-priority celery worker queue

import config

from server import create_app, db, g, celery_app
from server.models import User

app = create_app()
ctx = app.app_context()
ctx.push()

task = "eth_manager.celery_tasks.create_new_blockchain_wallet"

kwargs = {
        "wei_target_balance": 10000,
        "wei_topup_threshold": 10000,
        }

u = db.session.query(User).execution_options(showall=True).first()

celery_app.signature(task, kwargs=kwargs, args=None).apply_async(queue='high-priority')
