
from django.http import request
from rest_framework import serializers
from .models import UserProfile, User, Set


class SetSerializer(serializers.HyperlinkedModelSerializer):
    owner = serializers.HyperlinkedRelatedField(view_name='user-detail', read_only=True)
    class Meta:
        model = Set
        fields = ['url', 'name', 'owner', 'reps', 'weight']

class UserProfileSerializer(serializers.ModelSerializer):
    
    class Meta:
            model = UserProfile
            fields = ['dob']


class UserSerializer(serializers.HyperlinkedModelSerializer):
    profile = UserProfileSerializer(required=True)
    sets = SetSerializer(many=True, required=False)
    class Meta:
        model = User
        fields = ('url', 'email', 'first_name', 'last_name', 'password', 'profile', 'sets')
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        profile_data = validated_data.pop('profile')
        password = validated_data.pop('password')
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        UserProfile.objects.create(user=user, **profile_data)
        return user

    def update(self, instance, validated_data):
        profile_data = validated_data.pop('profile')
        profile = instance.profile

        instance.email = validated_data.get('email', instance.email)
        instance.save()

        profile.dob = profile_data.get('dob', profile.dob)
        profile.save()

        return instance





        