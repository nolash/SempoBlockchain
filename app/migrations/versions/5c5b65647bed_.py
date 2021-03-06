"""empty message

Revision ID: 5c5b65647bed
Revises: ae98d36420a1
Create Date: 2019-09-23 19:52:38.108636

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '5c5b65647bed'
down_revision = 'ae98d36420a1'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('transfer_card', sa.Column('transfer_account_id', sa.Integer(), nullable=True))
    op.create_foreign_key(None, 'transfer_card', 'user', ['transfer_account_id'], ['id'])
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_constraint(None, 'transfer_card', type_='foreignkey')
    op.drop_column('transfer_card', 'transfer_account_id')
    # ### end Alembic commands ###
