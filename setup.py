try:
  from setuptools import setup
  kw = {'entry_points':
  '''[console_scripts]
  discoball = discoball:main
  ''',
  'zip_safe': False}
except ImportError:
  from distutils.core import setup
  kw = {'scripts': ['scripts/discoball']}

setup(name='discoball',
      version='0.1.0',
      url='https://github.com/bkad/discoball',
      description='A simple stream filter to highlight patterns',
      classifiers=[
        'Development Status :: 3 - Alpha',
        'Intended Audience :: Developers',
        'Programming Language :: Python :: 2.7',
        ],
      author='Kevin Le',
      author_email='solnovus@gmail.com',
      py_modules=['discoball'],
      install_requires=['fabulous','argparse'],
      **kw)
