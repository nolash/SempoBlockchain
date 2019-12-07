"""empty message

Revision ID: 21a880175a91
Revises: 2a137ac5d786
Create Date: 2019-12-05 15:08:25.573551

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '21a880175a91'
down_revision = '2a137ac5d786'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.alter_column('token', 'address',
               existing_type=sa.VARCHAR(),
               nullable=True)
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.alter_column('token', 'address',
               existing_type=sa.VARCHAR(),
               nullable=False)
    # ### end Alembic commands ###
