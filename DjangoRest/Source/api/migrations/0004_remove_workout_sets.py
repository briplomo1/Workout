# Generated by Django 4.0.4 on 2022-06-03 04:12

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0003_exercise_workout_remove_set_name_alter_set_owner_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='workout',
            name='sets',
        ),
    ]
