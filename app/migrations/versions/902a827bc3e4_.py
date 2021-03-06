"""empty message

Revision ID: 902a827bc3e4
Revises: eb7ea57ebad0
Create Date: 2018-09-11 10:58:02.554935

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '902a827bc3e4'
down_revision = 'eb7ea57ebad0'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('pin_to_public_id',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('PIN', sa.Integer(), nullable=True),
    sa.Column('public_id', sa.String(), nullable=True),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('feedback',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('created', sa.DateTime(), nullable=True),
    sa.Column('rating', sa.Float(), nullable=True),
    sa.Column('additional_information', sa.String(), nullable=True),
    sa.Column('transfer_account_id', sa.Integer(), nullable=True),
    sa.ForeignKeyConstraint(['transfer_account_id'], ['transfer_account.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('feedback')
    op.drop_table('pin_to_public_id')
    # ### end Alembic commands ###
