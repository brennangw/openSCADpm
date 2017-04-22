import os
import sys

try:
        from setuptools import setup
except ImportError:
        from distutils.core import setup

dependencies = ['docopt', 'termcolor']

'''
def publish():
        os.system("python setup.py sdist upload")

if sys.argv[-1] == "publish":
        publish()
        sys.exit()
'''

setup(
        name='ospm',
        version='0.0.1',
        description='THIS IS OSPM',
        url='github link',
        author='JIAXIN SU',
        author_email='email address',
        install_requires=dependencies,
        packages=['ospm'],
        entry_points= {
                'console_scripts': [
                        'ospm=ospm.main:start',
                ]
        },
        classifiers=[
                'Development Statu :: Beta',
                'Intended Audience :: Developers',
                'Topic :: Utilities',
                'License :: MIT LICENSE',
                'Natural Language :: English',
                'Operating System :: OS Independent',
                'Programming Language :: Python',
                'Programming Language :: Python :: 2.6',
                'Programming Language :: Python :: 2.7',
        ],
)
