"""empty message

Revision ID: dadfc046c4cb
Revises: 5ac46b68b339
Create Date: 2018-11-01 17:01:46.080024

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'dadfc046c4cb'
down_revision = '5ac46b68b339'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('referral',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('authorising_user_id', sa.Integer(), nullable=True),
    sa.Column('created', sa.DateTime(), nullable=True),
    sa.Column('updated', sa.DateTime(), nullable=True),
    sa.Column('first_name', sa.String(), nullable=True),
    sa.Column('last_name', sa.String(), nullable=True),
    sa.Column('reason', sa.String(), nullable=True),
    sa.Column('_phone', sa.String(), nullable=True),
    sa.Column('referring_user_id', sa.Integer(), nullable=True),
    sa.ForeignKeyConstraint(['referring_user_id'], ['user.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('referral')
    # ### end Alembic commands ###
